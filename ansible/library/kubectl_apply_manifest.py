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
#!/usr/bin/python
import os
from ansible.module_utils.basic import AnsibleModule


def kubectl_apply_manifest(module, manifest, kubeconfig):
    kubectl_path = module.get_bin_path('kubectl', required=True)
    args = [kubectl_path, '--kubeconfig', kubeconfig, 'apply', '-f', manifest]
    return module.run_command(args)


def main():
    module = AnsibleModule(
        argument_spec=dict(
            manifest=dict(required=True),
            kubeconfig=dict(default=os.environ['KUBECONFIG'])
        ),
    )

    manifest = module.params['manifest']
    kubeconfig = module.params['kubeconfig']

    if kubeconfig is None:
        msg = "Could not apply manifest, kubeconfig not specified"
        module.fail_json(msg=msg)

    rc, stdout, stderr = kubectl_apply_manifest(module, manifest, kubeconfig)
    if rc == 0:
        module.exit_json(changed=True, stdout=stdout)
    else:
        msg = "Could not apply manifest"
        module.fail_json(msg=msg + " " + stderr)

if __name__ == "__main__":
    main()
