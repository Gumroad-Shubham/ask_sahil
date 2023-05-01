A strategy is identified by the name of its folder (directory).
Names of all strategies must end with "python" or "ruby" denoting the language they're written in.
The main_controller decides which strategy to use.
Each strategy can access and may create common knowledge (book pdf, txt).
A strategy may use its own directory to store some preprocessed data (embeddings etc). The strategy should first check the existence of preprocessed data, and should be able to generate it if it is not already present.
Each strategy should have a file named 'main' and a method inside it named ask_a_question which accepts a single string and returns a dictionary containing a single string containing the answer. The method should be inside a module which is named as PascalCase version of the strategy name
No strategy should print anything by default. If print statements are there, use file-scoped variables to disable them.
Voice stuff stays in main_controller, decoupled from strategies.
