// create user
// docs - https://api.mattermost.com/#operation/CreateUser

import fetch from 'node-fetch';
import { readFile } from '@/utilities.js';



const importUsers = async () => JSON.parse(await readFile('../generated/users-object.json'));


const loginUser = async (apiKey: string, siteURL: string, mail: string, uid: string) => {

    const body = {
        "email": mail,
        "username": uid,
        "auth_data": uid,
        "auth_service": "ldap",
    }

    const options = {
        method: 'POST',
        body: JSON.stringify(body),
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + apiKey
        }
    }

    return await fetch(siteURL + '/api/v4' + '/users', options)
        .then((res) => res.json())
}

export const loginAllUsers = async (apiKey: string, siteURL: string) => {

    const usersPayload = await importUsers()
    for (let i = 0; i < usersPayload.length; i++) {
        let { mail, uid } = usersPayload[i]
        const res = await loginUser(apiKey, siteURL, mail, uid)
        console.log('Logged in User # ' + i)
    }

}

