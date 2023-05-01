This project is based on [Ask My Book](https://github.com/slavingia/askmybook/) by **Sahil Lavingia** ([Github](https://github.com/slavingia) | [Twitter](https://sahillavingia.com/) | [Personal Website](https://sahillavingia.com/)).

## Setup
1. Install docker for your machine. For ubuntu
```
sudo apt-get update -y &&
sudo apt-get install -y docker.io
```
2. Make sure you have `OPENAI_KEY` in your environment. Get your key from [OpenAI](https://platform.openai.com/account/api-keys) and store it in your `~/.bashrc` like this

```
export OPENAI_KEY='your-key-here'
```
The project's `.env` file will pick it up from there.

3. From the project directory, build & run the container
```
docker-compose up --build
```

That's it, it should get successfully hosted on localhost!

Now call the api (http://localhost:3000/api/v1/ask) with params `question` and `strategy` like [this](http://localhost:3000/api/v1/ask?question=Who%20are%20you?&strategy=sahils_strategy_ruby).

You can also refer [Github Workflows](https://github.com/bhamshu/ask_sahil/tree/master/.github/workflows) to see how the project is being deployed.
