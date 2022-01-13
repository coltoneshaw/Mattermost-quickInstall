import { runCommand } from "@/utilities";
import { SCRIPTS_COMMANDS_DIR } from "@/env";

export const upgrade = async (version: versionString) => {

    await runCommand(`bash ${SCRIPTS_COMMANDS_DIR}/upgrade.sh ${version}`);
}
