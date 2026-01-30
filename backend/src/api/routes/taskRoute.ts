import { Router, Request, Response } from 'express';
import { Container } from 'typedi';
import {TaskController} from "../../controllers/Controller/TaskController";

const route = Router();

export default (app: Router) => {

  app.use('/tasks', route);

    const ctrl = Container.get(TaskController);

    route.post('/', (req: Request, res: Response) => ctrl.createTask(req, res));

    route.get('/', (req: Request, res: Response) => ctrl.listTasks(req, res));

    route.patch('/:id/complete', (req: Request, res: Response) => ctrl.completeTask(req, res));

    route.get('/:id', (req: Request, res: Response) => ctrl.getTaskById(req, res));

    route.delete('/:id', (req: Request, res: Response) => ctrl.deleteTask(req, res));
};
