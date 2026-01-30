import swaggerJsdoc from 'swagger-jsdoc';
import config from '../../config';

const options: swaggerJsdoc.Options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'OEM API Documentation',
      version: '1.0.0',
      description: 'API documentation for the OEM application',
      contact: {
        name: 'API Support',
        email: 'support@oem.com',
      },
    },
    servers: [
      {
        url: `http://localhost:${config.port}${config.api?.prefix ?? '/api'}`,
        description: 'Development server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
      schemas: {
        Role: {
          type: 'object',
          properties: {
            id: {
              type: 'string',
              description: 'Role ID',
            },
            name: {
              type: 'string',
              description: 'Role name',
            },
          },
          required: ['name'],
        },
        User: {
          type: 'object',
          properties: {
            id: {
              type: 'string',
              description: 'User ID',
            },
            email: {
              type: 'string',
              format: 'email',
              description: 'User email',
            },
            password: {
              type: 'string',
              format: 'password',
              description: 'User password',
            },
          },
        },
        ComplementaryTask: {
          type: 'object',
          properties: {
            id: {
              type: 'string',
              description: 'Complementary task ID',
              example: '507f1f77bcf86cd799439011',
            },
            responsibleTeam: {
              type: 'string',
              description: 'Responsible team name',
              example: 'Engineering Team',
            },
            categoryId: {
              type: 'string',
              description: 'The ID of the complementary task category',
              example: '507f1f77bcf86cd799439012',
            },
            mode: {
              type: 'string',
              enum: ['PARALLEL', 'BLOCKING'],
              description: 'The execution mode of the task',
              example: 'PARALLEL',
            },
            status: {
              type: 'string',
              enum: ['ONGOING', 'COMPLETED'],
              description: 'The current status of the task',
              example: 'ONGOING',
            },
          },
          required: ['responsibleTeam', 'categoryId', 'mode', 'status'],
        },
        ComplementaryTaskCategory: {
          type: 'object',
          properties: {
            identifier: {
              type: 'string',
              description: 'Unique identifier for the category',
              example: 'MAINT-001',
            },
            name: {
              type: 'string',
              description: 'Category name',
              example: 'Routine Maintenance',
            },
            description: {
              type: 'string',
              description: 'Category description',
              example: 'Regular maintenance tasks for equipment and facilities',
            },
            duration: {
              type: 'number',
              description: 'Default duration in minutes',
              example: 120,
            },
          },
          required: ['identifier', 'name', 'description', 'duration'],
        },
        IncidentType: {
          type: 'object',
          properties: {
            id: {
              type: 'string',
              description: 'Incident type ID (generated automatically)',
              example: '507f1f77bcf86cd799439011',
            },
            code: {
              type: 'string',
              pattern: '^T-INC\\d{3}$',
              description: 'Unique incident type code (format: T-INC###)',
              example: 'T-INC001',
            },
            name: {
              type: 'string',
              description: 'Incident type name',
              example: 'Equipment Failure',
            },
            description: {
              type: 'string',
              description: 'Detailed description of the incident type',
              example: 'Incident related to critical equipment failure',
            },
            severity: {
              type: 'string',
              enum: ['Minor', 'Major', 'Critical'],
              description: 'Incident severity level',
              example: 'Major',
            },
            parentTypeId: {
              type: 'string',
              description: 'ID of parent incident type (optional, for hierarchy)',
              example: '507f1f77bcf86cd799439012',
              nullable: true,
            },
            parentTypeName: {
              type: 'string',
              description: 'Name of parent incident type (read-only)',
              example: 'General Incident',
            },
          },
          required: ['code', 'name', 'description', 'severity'],
        },
        VesselVisitExecution: {
          type: 'object',
          properties: {
            identifier: {
              type: 'string',
              description: 'Unique identifier for the vessel visit execution',
              example: 'VVE-001',
            },
            vvnId: {
              type: 'string',
              description: 'Vessel Visit Notification ID',
              example: 'VVN-123',
            },
            operationPlanIdentifier: {
              type: 'string',
              description: 'Operation Plan identifier',
              example: 'OP-456',
            },
            actualArrival: {
              type: 'string',
              format: 'date-time',
              description: 'Actual arrival time',
              example: '2025-12-21T10:00:00Z',
            },
            actualBerth: {
              type: 'string',
              format: 'date-time',
              description: 'Actual berth time',
              example: '2025-12-21T11:00:00Z',
            },
            actualUnberth: {
              type: 'string',
              format: 'date-time',
              description: 'Actual unberth time',
              example: '2025-12-21T15:00:00Z',
            },
            actualDeparture: {
              type: 'string',
              format: 'date-time',
              description: 'Actual departure time',
              example: '2025-12-21T16:00:00Z',
            },
            status: {
              type: 'string',
              description: 'Execution status',
              example: 'IN_PROGRESS',
            },
            totalTurnaroundTime: {
              type: 'number',
              description: 'Total turnaround time in minutes',
              example: 360,
            },
            berthOccupancyTime: {
              type: 'number',
              description: 'Berth occupancy time in minutes',
              example: 240,
            },
            waitingTimeForBerthing: {
              type: 'number',
              description: 'Waiting time for berthing in minutes',
              example: 60,
            },
            arrivalDelay: {
              type: 'number',
              description: 'Arrival delay in minutes (negative for early arrival)',
              example: -10,
            },
            departureDelay: {
              type: 'number',
              description: 'Departure delay in minutes (negative for early departure)',
              example: 5,
            },
            operationDelays: {
              type: 'number',
              description: 'Operation delays in minutes',
              example: 15,
            },
          },
          required: ['identifier', 'vvnId'],
        },
        Error: {
          type: 'object',
          properties: {
            message: {
              type: 'string',
            },
          },
        },
      },
    },
  },
  apis: ['./src/api/routes/*.ts'], // Path to the API routes (TypeScript only in dev)
};

export const swaggerSpec = swaggerJsdoc(options);
