import argparse
import csv
import openai
from PyPDF2 import PdfReader
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


def extract_pages(
    page_text: str,
    index: int,
) -> str:
    """
    Extract the text from the page
    """
    if len(page_text) == 0:
        return []

    content = " ".join(page_text.split())
    outputs = [("Page " + str(index), content, count_tokens(content)+4)]

    return outputs


parser = argparse.ArgumentParser()

parser.add_argument("--pdf", help="Name of PDF")

args = parser.parse_args()
args.pdf = '../../common_knowledge/minimalist_entrepreneur.pdf'
filename = f"{args.pdf}"

reader = PdfReader(filename)

res = []
i = 1
for page in reader.pages:
    res += extract_pages(page.extract_text(), i)
    i += 1
df = pd.DataFrame(res, columns=["title", "content", "numtokens"])
df = df[df.tokens < 2046]

df.to_csv(f'{filename}.pages.csv', index=False)


def get_embedding(text: str, model: str):
    result = openai.Embedding.create(
        model=model,
        input=text
    )
    return result["data"][0]["embedding"]


def get_doc_embedding(text: str):
    return get_embedding(text, DOC_EMBEDDINGS_MODEL)


def compute_doc_embeddings(df: pd.DataFrame):
    """
    Create an embedding for each row in the dataframe using the OpenAI Embeddings API.

    Return a dictionary that maps between each embedding vector and the index of the row that it corresponds to.
    """
    return {
        idx: get_doc_embedding(r.content) for idx, r in df.iterrows()
    }

# CSV with exactly these named columns:
# "title", "0", "1", ... up to the length of the embedding vectors.


user_input = input(
    "Continuing will call openai api and cost you money. Type 'yes' in smallcase and without quotes to continue.\n")
if user_input == "yes":
    embeddings_filename = f'{filename}.embeddings.csv'
    if os.path.isfile(embeddings_filename):
        if input("The embeddings file already exists. Type 'yes' in smallcase and without quotes to recreate.\n") != "yes":
            exit()
    doc_embeddings = compute_doc_embeddings(df)
    import pdb
    pdb.set_trace()
    with open(embeddings_filename, 'w') as f:
        writer = csv.writer(f)
        writer.writerow(["title"] + list(range(4096)))
        for i, embedding in list(doc_embeddings.items()):
            writer.writerow(["Page " + str(i + 1)] + embedding)
