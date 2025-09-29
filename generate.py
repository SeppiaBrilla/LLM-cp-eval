import os
from dotenv import load_dotenv
from openai import OpenAI
import sys
from tqdm import tqdm
import anthropic

load_dotenv()

def ask_r1(prompt: str, system_prompt: str = "You are a helpful assistant."):
    api_key = os.getenv("DEEPSEEK_API_KEY")

    if not api_key:
        raise ValueError("API key not found. Please set DEEPSEEK_API_KEY in your .env file.")
    
    client = OpenAI(api_key=api_key, base_url="https://api.deepseek.com")
    response = client.chat.completions.create(
        model="deepseek-reasoner",
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": prompt}
        ],
        temperature=0  # deterministic response
    )
    return response.choices[0].message.content

def ask_gpt(prompt: str, system_prompt: str = "You are a helpful assistant."):
    api_key = os.getenv("OPENAI_API_KEY")

    if not api_key:
        raise ValueError("API key not found. Please set OPENAI_API_KEY in your .env file.")

    client = OpenAI(api_key=api_key)
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": prompt}
        ],
        temperature=0  # deterministic response
    )
    return response.choices[0].message.content

def ask_claude(prompt: str, system_prompt: str = "You are a helpful assistant."):
    api_key = os.getenv("CLAUDE_API_KEY")

    if not api_key:
        raise ValueError("API key not found. Please set CLAUDE_API_KEY in your .env file.")

    claude_client = anthropic.Anthropic(api_key=api_key)

    with claude_client.messages.stream(
        model="claude-sonnet-4-20250514",
        max_tokens=64000,
        temperature=0,  # deterministic response
        system=system_prompt,
        messages=[
            {"role": "user", "content": prompt}
        ],
    ) as stream:
        output_text = ""
        for event in stream:
            if event.type == "content_block_delta" and event.delta.type == "text_delta":
                output_text += event.delta.text
    return output_text

def generate(system_prompt:str, model_type:str):
    if model_type == 'gpt4':
        model_dir = 'GPT4'
        model_func = ask_gpt
    elif model_type == 'r1':
        model_dir = 'R1'
        model_func = ask_r1
    elif model_type == "claude4":
        model_dir = "Claude4"
        model_func = ask_claude
    else:
        raise ValueError(f"unknown llm {model_type}")
    for element in tqdm(os.listdir("./problems")):
        if not os.path.isdir(f'./problems/{element}'):
            continue
        with open(f'./problems/{element}/specification.txt') as f:
            content = f.read()
        lines = content.splitlines()
        assert lines[0] == "original:"
        original, modified = "", ""
        is_original = True
        for line in lines[1:]:
            if line == "modified:":
                is_original = False
            elif is_original:
                original += "\n" + line
            else:
                modified += "\n" + line
        if not os.path.exists(f'./problems/{element}/{model_dir}'):
            os.mkdir(f'./problems/{element}/{model_dir}')
        if not os.path.exists(f'./problems/{element}/{model_dir}/api_original.desc'):
            original_model = model_func(original, system_prompt)
            with open(f'./problems/{element}/{model_dir}/api_original.desc', 'w') as f:
                f.write(original_model)
        if not os.path.exists(f'./problems/{element}/{model_dir}/api_modified.desc'):
            modified_model = model_func(modified, system_prompt)
            with open(f'./problems/{element}/{model_dir}/api_modified.desc', 'w') as f:
                f.write(modified_model)

def main():
    if len(sys.argv) < 2:
        print(f"usage: python {sys.argv[0]} <llm_model>")
        return
    llm_model = sys.argv[1].lower()
    if not llm_model in ["gpt4", "claude4", "r1"]:
        print(f"llm {llm_model} not supported. Available are: gpt4, claude4, r1")
    with open("system_prompt.txt") as f:
        system_prompt = f.read()
    generate(system_prompt, llm_model)
    

if __name__ == "__main__":
    main()
