This strategy is a work in progress.

The weakness of currently implemented strategy (sahils_strategy_ruby) is that we first search for a document context, and then the model has to answer the question using that small context only.
What if the answer depends on a combination of separate parts from the book?

One way to solve this is by  [fine-tuning](https://platform.openai.com/docs/guides/fine-tuning) a model on question answers for the entire book. But who will write the entire book in the form of question answers?

We can use the language model itself to solve that problem!

Write a few (20-40) sample (answer, question) pairs and train a model to generate question from any given text. So if the model receives the input: "This strategy is a work in progress", it should output something like: "What is the status of this strategy?"

Now we divide the book into chunks as before and then run this model on all the chunks to generate a (answer, question) data set. 

Then we turn this data set into (question, answer) form and use this new data set to [fine-tune](https://platform.openai.com/docs/guides/fine-tuning) a new model.

This new model will answer user-queries. And since this has been fine tuned on the entire book, there is strong reason to believe that it may perform better than the existing strategy which has only a single chunk of the book available to it during any query.
