import { getRandomInt, generateName, writeTofile } from '@/utilities.js';
import {SETUP_DIR} from '@/env'
type LDIFType = 'group' | 'user'
type userObject = {
    mail: string
    uid: string
    password: string
}

type BaseLDIFReturn = {
    text: string
    dn: string
    userObject?: userObject
}


const returnUserLDIF = () => {
    const { fname, lname } = generateName();
    const uid = fname + lname + getRandomInt(0, 100000)
    const mail = `${uid}@planetexpress.com`
    const cn = uid + ' ' + lname

    const text = `

dn: cn=${cn},ou=people,dc=planetexpress,dc=com
changetype: add
objectClass: inetOrgPerson
cn: ${cn}
sn: ${lname}
uid: ${uid}
userPassword: ${uid}
givenName: ${fname}
mail: ${mail}
`

    return {
        text,
        dn: `cn=${cn},ou=people,dc=planetexpress,dc=com`,
        userObject: { mail, uid, password: uid }
    }
}

const returnGroupLDIF = () => {
    const { fname, lname } = generateName();
    const text = `

dn: cn=${fname}_${lname},ou=people,dc=planetexpress,dc=com
changetype: add
objectClass: Group
cn: ${fname}_${lname}
objectClass: top
groupType: 2147483650
`

    return {
        text,
        dn: `cn=${fname}_${lname},ou=people,dc=planetexpress,dc=com`
    }
}

const returnLDIF = (type: LDIFType): BaseLDIFReturn => {
    if (type === 'user') return returnUserLDIF();
    if (type === 'group') return returnGroupLDIF();
    throw Error
}

const generateFile = (total: number, fileName: string, type: LDIFType) => {

    let string = '';
    let dataArray: string[] = []
    let dataObject: userObject[] = []

    for (let i = 0; i < total; i++) {
        const returnLDIFObject = returnLDIF(type);
        const { dn, text, userObject } = returnLDIFObject;

        if (type === 'user' && userObject) dataObject.push(userObject)

        string += text
        dataArray.push(dn)
    }

    writeTofile(SETUP_DIR + '/ldap/' + fileName, string)

    return { dataObject, dataArray }
}

const generateUserMembershipFile = (users: string[], groups: string[]) => {

    let groupMembershipString = '';

    for (let group of groups) {

        let tempUsers = [...users].sort(() => 0.5 - Math.random())
        const numberOfMembers = getRandomInt(1, tempUsers.length) / 5;
        const selected = tempUsers.slice(0, numberOfMembers)
        let memberString = '';

        console.log(selected.length)

        for (let user of selected) {
            memberString += `member: ${user}
`
        }


        try {
            groupMembershipString += `

dn: ${group}
changetype: modify
add: member
${memberString}
`
        } catch (error) {
            console.error(error)
            console.log(memberString)
        }
    }

    writeTofile(SETUP_DIR + '/ldap/group-membership.ldif', groupMembershipString)
}


export const generateLDAPEnvironment = (totalUsers: number, totalGroups: number) => {
    const { dataObject, dataArray: users } = generateFile(totalUsers, 'add-users.ldif', 'user');
    const { dataArray: groups } = generateFile(totalGroups, 'add-groups.ldif', 'group');
    generateUserMembershipFile(users, groups)
    writeTofile(SETUP_DIR + '/ldap/users-object.json', JSON.stringify(dataObject))
}
