import mongoose from 'mongoose';
import { Db } from 'mongodb';
import config from '../../config';

export default async (): Promise<Db> => {
  // Set strictQuery to false to prepare for Mongoose 7
  mongoose.set('strictQuery', false);

  const connection = await mongoose.connect(config.databaseURL);
  return connection.connection.db;
};
