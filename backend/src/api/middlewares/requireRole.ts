
import { Request, Response, NextFunction } from 'express';
import config from '../../../config';

/**
 * Middleware to check if user has required role(s)
 * Must be used after isAuth middleware
 * 
 * Usage:
 *   route.get('/admin-only', middlewares.isAuth, requireRole('Administrator'), handler);
 *   route.get('/multi-role', middlewares.isAuth, requireRole(['Administrator', 'PortAuthority']), handler);
 */
export const requireRole = (allowedRoles: string | string[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      // Auth payload is attached by express-oauth2-jwt-bearer as req.auth
      const auth = (req as any).auth;
      
      if (!auth) {
        return res.status(401).json({
          error: 'Unauthorized',
          message: 'No authentication token provided'
        });
      }

      // Get roles from the custom namespace claim
      const rolesClaim = config.auth0.roleClaimNamespace;
      const userRoles = auth[rolesClaim] || [];

      // Convert allowedRoles to array if it's a string
      const rolesArray = Array.isArray(allowedRoles) ? allowedRoles : [allowedRoles];

      // Check if user has at least one of the required roles (case-insensitive)
      const hasRequiredRole = rolesArray.some(role => 
        userRoles.some((userRole: string) => userRole.toLowerCase() === role.toLowerCase())
      );

      if (!hasRequiredRole) {
        return res.status(403).json({
          error: 'Forbidden',
          message: `Access denied. Required role(s): ${rolesArray.join(', ')}`
        });
      }

      next();
    } catch (error) {
      return res.status(500).json({
        error: 'Internal Server Error',
        message: 'Error checking user authorization'
      });
    }
  };
};

export default requireRole;

