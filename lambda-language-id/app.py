import fasttext     # type: ignore


# Load the FastText language identification model
model = fasttext.load_model('lid.176.bin')


# Define the lambda function to detect language of input text
def detect_language(text: str) -> str:
    return model.predict(text)[0][0].split('__')[-1]


# Define the Lambda handler function
def handler(event, context):
    # Get the text input from the event
    if isinstance(event, str):
        text = event
    else:
        text = event['text']

    # Detect the language of the text using FastText
    language_code = detect_language(text)

    # Return the language code as the output of the Lambda function
    if isinstance(event, str):
        return language_code
    else:
        return {'language_code': language_code}
