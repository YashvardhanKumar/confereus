import './server/db';
import app from './app';


// dotenv.config();

const PORT = process.env.PORT || 3000; //port for https

app.get('/', (req, res) => {
    res.send('hello');
})

app
    .listen(PORT, () => console.log(`Listening on ${PORT}`));
