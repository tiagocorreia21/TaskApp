/**
 * Example of how to use MongoDB Memory Server in tests
 *
 * This file demonstrates the setup and teardown of in-memory database
 * for testing purposes.
 */

import {
  connectInMemoryDatabase,
  closeInMemoryDatabase,
  clearInMemoryDatabase,
} from '../../src/loaders/mongooseInMemory';

/**
 * Setup: Connect to a new in-memory database before running any tests.
 */
before(async () => {
  await connectInMemoryDatabase();
});

/**
 * Cleanup: Clear all test data after every test.
 */
afterEach(async () => {
  await clearInMemoryDatabase();
});

/**
 * Teardown: Remove and close the database and server.
 */
after(async () => {
  await closeInMemoryDatabase();
});

// Example test
describe('Example Test Suite', () => {
  it('should demonstrate in-memory database usage', async () => {
    // Your test code here
    // The database is automatically connected and ready to use
    console.log('✅ In-memory database is ready for testing');
  });
});
