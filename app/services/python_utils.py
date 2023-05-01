import sys
import argparse
import pickle
import csv
import openai
from PyPDF2 import PdfReader
import numpy as np
from transformers import GPT2TokenizerFast
from typing import Set
import pandas as pd
from dotenv import load_dotenv
import os

# Use load_env to trace the path of .env:
load_dotenv('.env')


openai.api_key = os.environ["OPENAI_KEY"]

COMPLETIONS_MODEL = "text-davinci-003"

MODEL_NAME = "curie"

DOC_EMBEDDINGS_MODEL = f"text-search-{MODEL_NAME}-doc-001"

tokenizer = GPT2TokenizerFast.from_pretrained("gpt2")


def count_tokens(text: str) -> int:
    """count the number of tokens in a string"""
    return len(tokenizer.encode(text))
