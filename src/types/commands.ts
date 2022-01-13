import { OptionValues } from 'commander';


export interface UpgradeOptions extends OptionValues {
    version: versionString
}

export interface InstallOptions extends OptionValues {
    version: versionString
    database: databaseType
    nginx: boolean
    ldap: boolean
    saml: boolean
  }