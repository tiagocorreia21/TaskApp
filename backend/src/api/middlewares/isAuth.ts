import { auth } from 'express-oauth2-jwt-bearer';
import config from '../../../config';

/**
 * JWT validation middleware using Auth0
 * This middleware validates the JWT token from the Authorization header
 * and attaches the decoded token payload to req.auth
 */
const isAuth = auth({
  audience: config.auth0.audience,
  issuerBaseURL: config.auth0.issuerBaseURL,
  tokenSigningAlg: config.auth0.tokenSigningAlg
});

export default isAuth;
