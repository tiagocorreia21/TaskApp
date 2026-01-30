export class Task {

  private _identifier!: string;
  private _title!: string;
  private _completed!: boolean;

  private constructor() {
  }

  get identifier(): string {
    return this._identifier;
  }

  get title(): string {
    return this._title;
  }

  get completed(): boolean {
    return this._completed;
  }

  public markAsCompleted(): void {
    this._completed = true;
  }

  public static create(identifier: string, title: string): Task {
    const task = new Task();
    task._title = title;
    task._identifier = identifier;
    task._completed = false;
    return task;
  }

  public static fromPersistence(identifier: string, title: string, completed: boolean): Task {
    const task = new Task();
    task._title = title;
    task._identifier = identifier;
    task._completed = completed;
    return task;
  }
}
