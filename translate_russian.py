import os
import re
from googletrans import Translator

# Initialize the translator
translator = Translator()

def translate_text(text):
    """Translates Russian text to English while preserving formatting."""
    try:
        translation = translator.translate(text, src='ru', dest='en').text
        return translation
    except Exception as e:
        print(f"Translation error: {e}")
        return text  # Return original if translation fails

def translate_match(match):
    """Translates only comments and string literals without modifying the code."""
    text = match.group(0)
    
    # Check if the text contains Cyrillic characters (i.e., Russian text)
    if re.search('[а-яА-Я]', text):
        print(f"Translating: {text}")

        # Preserve comment markers and string quotes
        if text.startswith("//"):
            return "// " + translate_text(text[2:].strip())  # Single-line comment
        elif text.startswith("/*") and text.endswith("*/"):
            return "/* " + translate_text(text[2:-2].strip()) + " */"  # Multi-line comment
        elif text.startswith('"') or text.startswith("'"):
            return text[0] + translate_text(text[1:-1]) + text[-1]  # String literals
        
    return text  # Return unchanged if no translation is needed

def process_file(file_path):
    """Processes a single .c or .h file, translating only comments and string literals."""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
    except UnicodeDecodeError:
        print(f"UTF-8 decode failed for {file_path}, trying windows-1251...")
        with open(file_path, 'r', encoding='windows-1251') as file:
            content = file.read()

    # Regex pattern to match comments and string literals
    pattern = r'(//.*|/\*[\s\S]*?\*/|".*?"|\'.*?\')'

    # Apply translation safely
    translated_content = re.sub(pattern, translate_match, content)

    # Overwrite the original file with the translated content
    with open(file_path, 'w', encoding='utf-8') as output_file:
        output_file.write(translated_content)

    print(f"Translated file: {file_path}")

def process_folder(folder_path):
    """Processes all .c and .h files in the specified folder and its subfolders."""
    for dirpath, _, filenames in os.walk(folder_path):
        for filename in filenames:
            if filename.endswith('.c') or filename.endswith('.h'):
                process_file(os.path.join(dirpath, filename))

# Set your folder path here
folder_path = r"path-to-directory\mlx90640_thermoimager_v1.1-main\main"

# Run the translation process
process_folder(folder_path)
