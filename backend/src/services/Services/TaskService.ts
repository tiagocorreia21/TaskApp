import { Service, Inject } from 'typedi';
import {Task} from "../../domain/Task";
import {ITaskService} from "../IServices/ITaskService";
import TaskRepository from "../../repos/TaskRepository";
import { TaskMapper } from "../../mappers/TaskMapper";
import { ITaskDTO } from "../../dto/ITaskDTO";

@Service()
export default class TaskService implements ITaskService {

  constructor(
    @Inject(() => TaskRepository) private taskRepo: TaskRepository
  ) {}

  async createTask(identifier: string, title: string): Promise<ITaskDTO> {

      const task = Task.create(identifier, title);

      await this.taskRepo.save(task);

      return TaskMapper.toDTO(task);
  }

  async getAllTasks(): Promise<ITaskDTO[]> {
    const tasks = await this.taskRepo.getAll();
    return tasks.map(task => TaskMapper.toDTO(task));
  }

  async deleteTask(identifier: string): Promise<void> {
    await this.taskRepo.delete(identifier);
  }

  async completeTask(identifier: string): Promise<void> {
    await this.taskRepo.completeTask(identifier);
  }
}
