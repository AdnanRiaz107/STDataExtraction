import os
import xml.etree.ElementTree as ET
import argparse

def extract_content(element):
    return element.text.strip() if element is not None and element.text is not None else ""

def convert_tcPOU_to_st(input_file_path, output_folder):
    try:
        # Parse the XML content using ET.parse() and ET.ElementTree
        tree = ET.parse(input_file_path)
        root = tree.getroot()

        # Extract the POU name for the output file
        pou_name = root.find(".//POU").get("Name")

        # Construct the output file path
        output_file_path = os.path.join(output_folder, f"{pou_name}.st")

        # List to store content
        content_list = []

        # Iterate through all elements
        for elem in root.iter():
            if elem.tag == "Declaration" or elem.tag == "ST":
                content = extract_content(elem)
                if content:
                    content_list.append(f"{content}\n\n")

        # Write the content list to the output file
        with open(output_file_path, "w") as output_file:
            output_file.writelines(content_list)

        print(f"Conversion successful. Content saved to {output_file_path}")
    except Exception as e:
        print(f"Error during conversion: {str(e)}")


# Example usage
user_input_file_path = r"c:\\Users\\adnan\\Desktop\\tcunit-tcpou - Copy\\FB_AdjustAssertFailureMessageToMax253CharLengthTest.TcPOU"  # Replace with the actual file path
output_folder_path = r"C:\\Users\\adnan\\Desktop\\TcPOUtoStconversion\\"  # Replace with the desired output folder

convert_tcPOU_to_st(user_input_file_path, output_folder_path)
