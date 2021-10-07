import * as passport from 'passport';
import { Strategy as GitHubStrategy } from 'passport-github';

import { baseURL, github, adminIdentifiers, allowedUserIdentifiers } from '../../config';

export const useGitHub = () => {
  passport.use(new GitHubStrategy({
    clientID: github.clientID,
    clientSecret: github.clientSecret,
    callbackURL: `${baseURL}/rest/auth/callback`,
  }, (accessToken, refreshToken, profile: any, cb) => {
    profile.isAdmin = adminIdentifiers.indexOf(profile.username) !== -1;
    const allowed_user = allowedUserIdentifiers.length === 0 || allowedUserIdentifiers.indexOf(profile.username) !== -1;
    cb(null, allowed_user?profile:false);
  }));
  return 'github';
};
