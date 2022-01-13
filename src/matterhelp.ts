#!/usr/bin/env node

import { Command } from 'commander';
import type { UpgradeOptions, InstallOptions } from '@/types/commands';
import { install, upgrade } from "@/commands";



const program = new Command();

program
  .version('0.0.1')
  .name('Matterhelp')
  .description('Tools to assist in building a Mattermost environment')

program
  .command('install')
  .description('Installs Mattermost based on the specifications in the config.json file and command flags')
  .option('-v, --version <version>', 'Install specific version of Mattermost. Must be in x.x.x format', 'latest')
  .option('-d, --database <database>', 'Choose specific database version for Mattermost. mysql / postgres', 'postgres')
  .option('-n, --nginx <boolean>', 'Enables nginx reverse proxy listening on port 80', true)
  .option('-l, --ldap <boolean>', 'Setup a LDAP test instance in your Mattermost environment, total users are pulled from the config file', false)
  .option('-s, --saml <boolean>', 'Setup a SAML test instance in your Mattermost environment', false)
  .action(({version, nginx, database, ldap, saml}: InstallOptions) => {
    console.log(`Attempting to install Mattermost ${version} with database ${database} and nginx ${nginx}. `);
    install(version, database, nginx)
});

program
  .command('upgrade')
  .description('Upgrade Mattermost to a specific version')
  .option('-v, --version <version>', 'Install specific version of Mattermost. Must be in x.x.x format', 'latest')
  .action(({version}: UpgradeOptions) => {
    console.log(`Attempting to upgrade Mattermost ${version}.`);
    upgrade(version)
});

program.parse(process.argv)
