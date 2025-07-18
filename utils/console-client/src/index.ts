import {frontChannelRequest} from './oauthClient.js';

console.log('Starting login ...')
const authorizationCode = await frontChannelRequest();
console.log(`Completed login and received authorization code: ${authorizationCode}`);
