import { readConfig, runCommand } from '@/utilities';

import { generateLDAPEnvironment } from '@/commands/ldap/addusers';
import { loginAllUsers } from '@/commands/ldap/loginUsers';
const { numUsers, numGroups, siteURL, apiKey  } = await readConfig();
import { SCRIPTS_COMMANDS_DIR } from '@/env';

export const setupLDAP = async () => {
    await runCommand(`bash ${SCRIPTS_COMMANDS_DIR}/ldap.sh initialSetup`)
    await generateLDAPEnvironment(numUsers, numGroups);
    await runCommand(`bash ${SCRIPTS_COMMANDS_DIR}/ldap.sh addLdifUsers`)
    await loginAllUsers(apiKey, siteURL)
}
