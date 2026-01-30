import mongoose, { Schema, Document, Model } from 'mongoose';

export interface ITaskDocument extends Document {
  identifier: string;
  title: string;
  completed: boolean;
}

const TaskSchema: Schema = new Schema<ITaskDocument>({
  identifier: { type: String, required: true, unique: true, index: true },
  title: { type: String, required: true, trim: true },
  completed: { type: Boolean, required: true, default: false },
}, {
  timestamps: true,
});

const TaskModel: Model<ITaskDocument> = mongoose.model<ITaskDocument>('Task', TaskSchema);

export default TaskModel;
