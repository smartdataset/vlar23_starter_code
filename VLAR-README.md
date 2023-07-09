# VLAR Challenge: Starter Submission Code.
   
This code is modified from the SMART-101 code here: https://github.com/merlresearch/SMART

This is a starter code demonstrating how to format your pre-trained model for evaluation. See `solve_VLAR.py` for details. 
This code shows where to expect to read the test/val puzzles from, and how to produce 
the output, which can be evaluated using our VLAR challenge evaluation code. 


Please see the predict_on_challenge_data() function below for details. Formally, the code shows four steps:

- To read the puzzles (see data_loader.py, SMART_Challenge_Data class)
- Get/load the prediction/solution model: (see `solve_VLAR.py`: `get_SMART_solver_model()`)
- Run the prediction model on the test puzzles and collect responses: (see `solve_VLAR.py` : `make_predictions()`
- Collect the responses in a json file for evaluation: (see `solve_VLAR.py`: `make_response_json()`

For this demo, we provide a pretrained ResNet-50 + BERT pre-trained model trained
on the SMART-101 dataset in the puzzle_split mode using the code in the above repo.
This model is provided in `./checkpoints/ckpt_resnet50_bert_212.pth`

See `scripts.sh` file for the command lines to train the model on SMART-101 dataset and how to run the trained model on the VLAR challenge val and test datasets. 

Specifically, note that the VLAR-val.json and VLAR-test.json files containing the VLAR challenge puzzles
are assumed to be kept in `/dataset/` folder, and a method should write the responses to `/submission/submission.json`
as described in `make_predictions()`. 

Note
----
In this demo, we do not use the answer candidate options within the model. However, 
a user may chose to have additional inputs to the model for taking in the options.


## Participation Guidelines

Participate in the contest by registering on the [EvalAI challenge page](https://eval.ai/web/challenges/challenge-page/2088/overview) and creating a team. Participants will upload docker containers with their agents that are evaluated on an AWS GPU-enabled instance. Before pushing the submissions for remote evaluation, participants should test the submission docker locally to ensure it is working. Instructions for training, local evaluation, and online submission are provided below.

### Local Evaluation

1. Clone the challenge repository:

    ```bash
    git clone https://github.com/merlresearch/SMART-101-Starter.git
    cd SMART-101-Starter
    ```

1. Implement your own model or try one of ours. We provide a simple baseline in `solve_VLAR.py` that uses pretrained ResNet-50 + BERT pre-trained model trained on SMART-101 dataset.


1. Install [docker](https://docs.docker.com/engine/install/).

1. Modify the provided Dockerfile (`Dockerfile`) if you need custom modifications. Let’s say your code needs a custom checkpoint of a model you trained and needs `transformers` package, the dependencies should be pip installed and additional files should be explicitly added:

    ```dockerfile
    # install dependencies using pip
    RUN pip install transformers

    ADD custom_ckpt.pth /ckpt.pth
    ```
    Build your docker container using: `docker build . --file Dockerfile -t smart_101_submission`.

    Note #1: you may need `sudo` privileges to run this command.

1. Evaluate your docker container locally:
    ```bash
    # Testing on val split
    docker run -v /path/to/local/copy/of/dataset/:/dataset/ --docker-name smart_101_submission
    ```
    If the above command runs successfully you will get an output similar to:
    ```
    2023-03-01 16:35:02,244 loading model ...
    2023-03-01 16:35:02,244 making predictions using the model
    2023-03-01 16:35:02,244 writing the model responses to file
    2023-03-01 16:35:02,244 done!
    ```
    Note: a similar command will be run to evaluate your submission for the leaderboard. **Please submit your docker for remote evaluation (below) only if it runs successfully on your local setup.** 

### Online submission

Follow instructions in the `submit` tab of the EvalAI challenge page to submit your docker image. Note that you will need a version of EvalAI `>= 1.3.15`. Pasting those instructions here for convenience:

```bash
# Installing EvalAI Command Line Interface
pip install "evalai>=1.3.15"

# Set EvalAI account token
evalai set_token <your EvalAI participant token>

# Push docker image to EvalAI docker registry
# Val phase
evalai push <image>:<tag> --phase smart-101-vlar-dev2023-2088

# Test phase
evalai push <image>:<tag> --phase smart-101-vlar-test2023-2088
```

The challenge consists of the following phases:

1. **Val phase**: The purpose of this phase/split is sanity checking -- to confirm that our remote evaluation reports the same result as the one you’re seeing locally. Each team is allowed maximum of 100 submissions per day for this phase, but please use them judiciously. We will block and disqualify teams that spam our servers.
1. **Test Challenge phase**: This phase/split will be used to decide challenge winners. Each team is allowed a total of 10 submissions until the end of challenge submission phase. The highest performing of these 10 will be automatically chosen. Results on this split will not be made public until the announcement of final results at the [VLAR workshop at ICCV](https://wvlar.github.io/iccv23/).

Note: Your submission will be evaluated on 100 puzzle and will have a total available time of 5 mins to finish. Your submissions will be evaluated on AWS EC2 p2.xlarge instance which has a Tesla K80 GPU (12 GB Memory), 4 CPU cores, and 61 GB RAM. If you need more time/resources for evaluation of your submission please get in touch. If you face any issues or have questions you can ask them by opening an issue on this repository.
