# -*- encoding: utf-8 -*- 
# ============LICENSE_START======================================================= 
# org.onap.vvp/engagementmgr
# ===================================================================
# Copyright © 2017 AT&T Intellectual Property. All rights reserved.
# ===================================================================
#
# Unless otherwise specified, all software contained herein is licensed
# under the Apache License, Version 2.0 (the “License”);
# you may not use this software except in compliance with the License.
# You may obtain a copy of the License at
#
#             http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
#
# Unless otherwise specified, all documentation contained herein is licensed
# under the Creative Commons License, Attribution 4.0 Intl. (the “License”);
# you may not use this documentation except in compliance with the License.
# You may obtain a copy of the License at
#
#             https://creativecommons.org/licenses/by/4.0/
#
# Unless required by applicable law or agreed to in writing, documentation
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ============LICENSE_END============================================
#
# ECOMP is a trademark and service mark of AT&T Intellectual Property.
require "pathname"

def provision(box, boxen, hosts, conf)

  ansible_groups = Hash.new { |h,k| h[k] = [] }
  boxen.each do |box|
    box["groups"].each do |group|
      ansible_groups[group] << box["name"]
    end
  end

  defined_vms = boxen.map {|b| b["name"]}

  requested_vms = defined_vms & ARGV
  if requested_vms.empty?
    requested_vms = defined_vms
  end

  provisioning_groups = [ 'bootstrap', 'ceph', 'container-hosts' ]
  provisioning_group = (box["groups"] & provisioning_groups).last
  return unless provisioning_group
  return unless box["name"] == (requested_vms & ansible_groups[provisioning_group]).last

  conf.vm.provision "ansible" do |ansible|
    # note: ansible is launched from root_path, so paths specified here are relative to that.
    ansible.extra_vars          = {hosts: hosts}
    ansible.groups              = ansible_groups
    ansible.limit               = [provisioning_group,"127.0.0.1"]
    ansible.playbook            = Pathname(ENV["ANSIBLE_CONFIG"]).parent.join("infrastructure.yml").to_path
    ansible.vault_password_file = ENV["ANSIBLE_VAULT_PASSWORD_FILE"]
    ansible.inventory_path      = Pathname(ENV["DEVKIT_ZONE_DIR"]).join("inventory").to_path
  end
end # ansible
