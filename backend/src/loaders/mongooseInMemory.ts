import mongoose from 'mongoose';
import { MongoMemoryServer } from 'mongodb-memory-server';
import { Db } from 'mongodb';

let mongoServer: MongoMemoryServer | null = null;

/**
 * Connect to the in-memory database.
 */
export const connectInMemoryDatabase = async (): Promise<Db> => {
  // Check if already connected
  if (mongoose.connection.readyState === 1) {
    return mongoose.connection.db;
  }

  // Set strictQuery to false to prepare for Mongoose 7
  mongoose.set('strictQuery', false);

  // Create an instance of MongoMemoryServer with specific configuration
  mongoServer = await MongoMemoryServer.create({
    instance: {
      dbName: 'test',
      storageEngine: 'ephemeralForTest', // Use ephemeral storage engine
      launchTimeout: 60000, // Increase timeout to 60 seconds
    },
    binary: {
      version: '6.0.12', // Use a stable version
      downloadDir: './mongodb-binaries', // Specify download directory
    },
  });

  const mongoUri = mongoServer.getUri();

  const connection = await mongoose.connect(mongoUri);

  return connection.connection.db;
};

/**
 * Drop database, close the connection and stop mongod.
 */
export const closeInMemoryDatabase = async () => {
  if (mongoose.connection.readyState !== 0) {
    await mongoose.connection.dropDatabase();
    await mongoose.connection.close();
  }

  if (mongoServer) {
    await mongoServer.stop();
    mongoServer = null;
    console.log('🛑 MongoDB Memory Server stopped');
  }
};

/**
 * Remove all the data for all db collections.
 */
export const clearInMemoryDatabase = async () => {
  if (mongoose.connection.readyState !== 0) {
    const collections = mongoose.connection.collections;

    for (const key in collections) {
      const collection = collections[key];
      await collection.deleteMany({});
    }

    console.log('🧹 Database cleared');
  }
};

export default connectInMemoryDatabase;

