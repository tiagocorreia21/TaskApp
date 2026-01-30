import { Service, Inject } from 'typedi';
import { Task } from "../domain/Task";
import {ITaskPersistence} from "../dataschema/ITaskPersistence";
import {Model, Document} from "mongoose";
import {ITaskRepository} from "../services/IRepos/ITaskRepository";

@Service()
export default class TaskRepository implements ITaskRepository {
    constructor(
        @Inject('taskSchema') private taskSchema: Model<ITaskPersistence & Document>
    ) {}

    async save(task: Task): Promise<Task> {
        const data: Partial<ITaskPersistence> = {
            identifier: task.identifier,
            title: task.title,
            completed: task.completed,
        };

        const updated = await this.taskSchema.findOneAndUpdate(
            { identifier: task.identifier },
            { $set: data },
            { upsert: true, new: true, setDefaultsOnInsert: true }
        ).lean().exec();

        return Task.fromPersistence(updated.identifier, updated.title, updated.completed);
    }

    async getAll(): Promise<Task[]> {
        const docs = await this.taskSchema.find().lean().exec();
        return docs.map(d => Task.fromPersistence(d.identifier, d.title, d.completed));
    }

    async delete(taskId: string): Promise<void> {
        const result = await this.taskSchema.deleteOne({ identifier: taskId }).exec();

        if (result.deletedCount === 0) {
            throw new Error(`Task with identifier ${taskId} not found`);
        }
    }

    async completeTask(taskId: string): Promise<void> {
        const result = await this.taskSchema.updateOne(
            { identifier: taskId },
            { $set: { completed: true } }
        ).exec();

        if (result.matchedCount === 0) {
            throw new Error(`Task with identifier ${taskId} not found`);
        }
    }
}
