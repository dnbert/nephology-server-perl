package NephologyServer::Install;

use strict;
use File::Temp;
use YAML;
use JSON;
use Mojo::Base 'Mojolicious::Controller';

use NephologyServer::Config;
use NephologyServer::DB;
use NephologyServer::Validate;
use Node;
use Node::Manager;
use LookupKey::Manager;
use KeyParam::Manager;
use MapCasteRule::Manager;


my @salt = ( '.', '/', 0 .. 9, 'A' .. 'Z', 'a' .. 'z' );


sub set_rule {
	my $self = shift;
	my $boot_mac = $self->stash("boot_mac");
	my $rule = $self->stash("rule");

	my $Config = NephologyServer::Config::config($self);
        my $Node = NephologyServer::Validate::validate($self,$boot_mac);

        if($Node == '0') {
                return $self->render(
                        text => "Couldn't find $boot_mac",
                        status => "404"
                );
        }


	$self->stash("srv_addr" => $Config->{'server_addr'});
	$self->stash("mirror_addr" => $Config->{'mirror_addr'});
	$Node->admin_password(crypt($Node->{'admin_password'}, _gen_salt(2)));
	# Make sure the requested rule is mapped to this machine before returning it


	my $MapCasteRules = MapCasteRule::Manager->get_map_caste_rules(
		require_objects => ['caste_rule'],
		query => [
			caste_id => $Node->caste_id,
			caste_rule_id => $rule,
		],
		limit => 1,
	);
	my $CasteRule = @$MapCasteRules[0]->caste_rule;
	if (ref $CasteRule) {
		if ($CasteRule->template) {
            $self->stash("db_rule_info" => $CasteRule);
            $self->stash("db_node_info" => $Node);
			return $self->render(
				template => $CasteRule->template,
				format   => 'txt'
			);
		} elsif ($CasteRule->url) {
			$self->redirect_to("http://" . $Config->{'server_addr'} . $CasteRule->url);
		} else {
			return $self->render(
				text   => "No template or url defined",
				status => 500
			);
		}
	} else {
		return $self->render(
			text   => "Rule [$rule] not valid for [$boot_mac]",
			status => 403
		);
	}
}

sub info {
	my $self = shift;
	my $boot_mac = $self->stash("boot_mac");
	my $key_name = $self->stash("key_name");
	my $param_name = $self->stash("param_name");

	my $Config = NephologyServer::Config::config($self);
        my $Node = NephologyServer::Validate::validate($self, $boot_mac);

        if($Node == '0') {
                return $self->render(
                        text => "Couldn't find $boot_mac",
                        status => "404"
                );
        }

	my $lookup_key_id = @{LookupKey::Manager->get_lookup_keys(
                query => [
				key_name => $key_name,
			],
        )}[0]->{id};

	my $key_param_value = @{KeyParam::Manager->get_key_params(
                query => [
				key_id => $lookup_key_id,
				param_name => $param_name,
			],
        )}[0]->{param_value};

	return $self->render(
		text => $key_param_value,
		status => 200
	);
}

sub install_machine {
	my $self = shift;
	my $boot_mac = $self->stash("boot_mac");

        my $Node = NephologyServer::Validate::validate($self,$boot_mac);

        if($Node == '0') {
                return $self->render(
                        text => "Couldn't find $boot_mac",
                        status => "404"
                );
        }

	my $MapCasteRules = MapCasteRule::Manager->get_map_caste_rules(
		require_objects => ['caste_rule'],
		query => [
			caste_id => $Node->caste_id,
		],
		sort_by => 't1.priority, t1.caste_rule_id'
	);

	my @columns = qw(id description url template);
	my @rule_list;

	for my $MapCasteRule (@$MapCasteRules) {	
		my $rule_item;
		for my $c (@columns) {
			$rule_item->{$c} = $MapCasteRule->caste_rule->{$c};
		}
		push @rule_list, $rule_item;
	}

	my $install_list = {
		'version_required' => 2,
		'runlist'          => \@rule_list,
	};

	$self->render(json => $install_list);
}

sub discovery {
	my $self = shift;
	my $boot_mac = $self->stash("boot_mac");
	my $Config = NephologyServer::Config::config($self);
	
	unless($Config->{'discovery'} eq 'enable') {
		return $self->render(
                        text   => "Discovery mode is not enabled",
                        status => 403
                );
	}

	my $json = $self->req->body;
	my $ohai = decode_json($json);

	open (OHAI, ">>$Config->{'discovery_path'}/$boot_mac");
	print OHAI $json;
	close (OHAI);

	my $NodeObject = Node->new(
		ctime => time,
		mtime => time,
		asset_tag => '',
		admin_user =>  '',
		admin_password => '',
		ipmi_user => '',
		ipmi_password => '',
		caste_id => '0',
		status_id => '1',
		domain => '',
		primary_ip => '',
		hostname => '',
		boot_mac => $boot_mac,
	);
	$NodeObject->save;

	my @rule_list;
        my $install_list = {
                'version_required' => 2,
                'runlist'          => \@rule_list,
        };

        $self->render(json => $install_list);
}

# uses global @salt to construct salt string of requested length
sub _gen_salt {
	my $count = shift;

	my $salt;
	for (1..$count) {
		$salt .= (@salt)[rand @salt];
	}

	return $salt;
}

1;
