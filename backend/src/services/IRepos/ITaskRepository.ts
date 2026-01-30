import {Task} from "../../domain/Task";

export interface ITaskRepository {

    save(task: Task): Promise<Task>;

    getAll(): Promise<Task[]>;

    delete(taskId: string): Promise<void>;

    completeTask(taskId: string): Promise<void>;
}
