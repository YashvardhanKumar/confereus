import './server/db';
import {app,http} from './app';
// import io from './socket';

// dotenv.config();

const PORT = process.env.PORT || 3000; //port for https

app.get('/', (req, res) => {
    res.send('hello');
})

http
    .listen(PORT, () => console.log(`Listening on ${PORT}`));