import { Container } from 'typedi';
import LoggerInstance from './logger';

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export default ({ mongoConnection, schemas, controllers, repos, services}: {
                    mongoConnection;
                    schemas: { name: string; schema: string }[],
                    controllers: {name: string; path: string }[],
                    repos: {name: string; path: string }[],
                    services: {name: string; path: string }[] }) => {
  try {
    Container.set('logger', LoggerInstance);

    schemas.forEach(m => {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const schema = require(m.schema).default;
      Container.set(m.name, schema);
    });

    repos.forEach(m => {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const repoClass = require(m.path).default;
      // Just requiring the class is enough - @Service() decorator will register it
      Container.set(m.name, repoClass);
    });

    services.forEach(m => {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const serviceClass = require(m.path).default;
      // Just requiring the class is enough - @Service() decorator will register it
      Container.set(m.name, serviceClass);
      });

    controllers.forEach(m => {
      // load the @Service() class by its path
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const controllerClass = require(m.path).default;
      // Just requiring the class is enough - @Service() decorator will register it
      Container.set(m.name, controllerClass);
    });

    return;
  } catch (e) {
    LoggerInstance.error('🔥 Error on dependency injector loader: %o', e);
    throw e;
  }
};
