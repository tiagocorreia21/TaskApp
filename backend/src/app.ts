import 'reflect-metadata';

import config from '../config';

import express from 'express';

import Logger from './loaders/logger';

async function startServer() {

  const app = express();

  await require('./loaders').default({ expressApp: app });

  const server = app.listen(config.port, () => {

    Logger.info(`Server listening on port: ${config.port}`);

    })
    .on('error', (err) => {
      Logger.error(err);
      process.exit(1);
      return;
  });

  // Graceful shutdown handling
  const gracefulShutdown = async (signal: string) => {

    Logger.info(`\n${signal} received. Closing server gracefully...`);

    server.close(() => {
      Logger.info('Server closed successfully');
      process.exit(0);
    });

    // Force close after 10 seconds
    setTimeout(() => {
      Logger.error('Could not close connections in time, forcefully shutting down');
      process.exit(1);
    }, 10000);
  };

  // Handle different termination signals
  process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
  process.on('SIGINT', () => gracefulShutdown('SIGINT'));
  process.on('SIGUSR2', () => gracefulShutdown('SIGUSR2'));
}

startServer();
