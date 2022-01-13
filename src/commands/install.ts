import { runCommand } from "@/utilities";

import { SCRIPTS_COMMANDS_DIR, SCRIPTS_DATABASE_DIR } from "@/env";

const installDatabase = async (type: databaseType) => {
    await runCommand(`bash ${SCRIPTS_DATABASE_DIR}/databaseSetup.sh ${type}`);
}


const installMattermost = async (version: versionString, databaseType: databaseType) => {
    await runCommand(`bash ${SCRIPTS_COMMANDS_DIR}/installMattermost.sh ${version} ${databaseType}`)
}

export const install = async (version: versionString, databaseType: databaseType, nginx: boolean) => {
    await installDatabase('postgres')
    await installMattermost(version, databaseType)
}