import { Task } from '../domain/Task';
import { Mapper } from '../core/infra/Mapper';
import { ITaskDTO } from '../dto/ITaskDTO';

export class TaskMapper extends Mapper {

    public static toDTO(task: Task): ITaskDTO {
        return {
            identifier: task.identifier,
            title: task.title,
            completed: task.completed
        } as ITaskDTO;
    }

    public static toDomain(raw: ITaskDTO): Task {
        return Task.create(raw.identifier, raw.title);
    }

    public static toPersistence(task: Task): ITaskDTO {
        return {
            identifier: task.identifier,
            title: task.title,
            completed: task.completed
        };
    }
}
