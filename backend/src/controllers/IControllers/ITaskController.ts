export interface ITaskController {

    createTask(req: any, res: any): Promise<void>;

    getTaskById(req: any, res: any): Promise<void>;

    completeTask(req: any, res: any): Promise<void>;

    deleteTask(req: any, res: any): Promise<void>;

    listTasks(req: any, res: any): Promise<void>;
}
