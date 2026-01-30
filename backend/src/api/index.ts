import { Router } from 'express';
import taskRoute from './routes/taskRoute';

export default () => {

	const app = Router();

	taskRoute(app);

	return app
}
