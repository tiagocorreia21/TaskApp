import { ITaskDTO } from "../../dto/ITaskDTO";

export interface ITaskService {

    createTask(identifier: string, title: string): Promise<ITaskDTO>;

    getAllTasks(): Promise<ITaskDTO[]>;

    deleteTask(taskId: string): Promise<void>;

    completeTask(taskId: string): Promise<void>;
}
