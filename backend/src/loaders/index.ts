import expressLoader from './express';
import dependencyInjectorLoader from './dependencyInjector';
import mongooseLoader from './mongoose';
import mongooseInMemoryLoader from './mongooseInMemory';
import Logger from './logger';

import config from '../../config';

export default async ({ expressApp }) => {

  const mongoConnection = config.useInMemoryDB ? await mongooseInMemoryLoader() : await mongooseLoader();

  const taskSchema = {
    name: 'taskSchema',
    schema: '../persistence/schemas/taskSchema',
  };

  const taskController = {
    name: 'TaskController',
    path: '../controllers/Controller/TaskController',
  };

  const taskRepo = {
    name: 'TaskRepo',
    path: '../repos/TaskRepository',
  };

  const taskService = {
    name: 'TaskService',
    path: '../services/Services/TaskService',
  };

  await dependencyInjectorLoader({
    mongoConnection,
    schemas: [
      taskSchema
    ],
    controllers: [
      taskController
    ],
    repos: [
      taskRepo
    ],
    services: [
      taskService
    ]
  });

  await expressLoader({ app: expressApp });

};
