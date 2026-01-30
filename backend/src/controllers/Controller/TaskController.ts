import {Service, Inject} from "typedi";
import { Request, Response } from "express";
import TaskService from "../../services/Services/TaskService";
import {ITaskController} from "../IControllers/ITaskController";

@Service()
export class TaskController implements ITaskController {

    constructor(
        @Inject(() => TaskService) private taskService: TaskService,
        @Inject('logger') private logger: typeof console
    ) {}

    async createTask(req: Request, res: Response): Promise<void> {
        try {
            const { identifier, title } = req.body;

            if (!identifier || !title) {
                res.status(400).json({ error: 'Identifier and title are required' });
                return;
            }

            const task = await this.taskService.createTask(identifier, title);

            res.status(201).json(task);
        } catch (error) {
            this.logger.error('Error creating task:', error);
            res.status(500).json({ error: 'Internal server error' });
        }
    }

    async getTaskById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            const tasks = await this.taskService.getAllTasks();
            const task = tasks.find(t => t.identifier === id);

            if (!task) {
                res.status(404).json({ error: 'Task not found' });
                return;
            }

            res.status(200).json(task);
        } catch (error) {
            this.logger.error('Error getting task by id:', error);
            res.status(500).json({ error: 'Internal server error' });
        }
    }

    async completeTask(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            await this.taskService.completeTask(id);
            res.status(200).json({ message: 'Task completed successfully' });
        } catch (error) {
            this.logger.error('Error completing task:', error);
            if (error instanceof Error) {
                res.status(404).json({ error: error.message });
            } else {
                res.status(500).json({ error: 'Internal server error' });
            }
        }
    }

    async deleteTask(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            await this.taskService.deleteTask(id);
            res.status(200).json({ message: 'Task deleted successfully' });
        } catch (error) {
            this.logger.error('Error deleting task:', error);
            if (error instanceof Error) {
                res.status(404).json({ error: error.message });
            } else {
                res.status(500).json({ error: 'Internal server error' });
            }
        }
    }

    async listTasks(req: Request, res: Response): Promise<void> {
        try {
            const tasks = await this.taskService.getAllTasks();
            res.status(200).json(tasks);
        } catch (error) {
            this.logger.error('Error listing tasks:', error);
            res.status(500).json({ error: 'Internal server error' });
        }
    }
}
