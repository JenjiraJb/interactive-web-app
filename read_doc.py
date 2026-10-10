import zipfile
import xml.etree.ElementTree as ET
import glob
import os

docx_files = glob.glob("*.docx")
print("Found docx files:", docx_files)

for docx_file in docx_files:
    print(f"\n=== Reading {docx_file} ===")
    with zipfile.ZipFile(docx_file) as z:
        xml_content = z.read('word/document.xml')
    tree = ET.fromstring(xml_content)
    
    paragraphs = []
    for p in tree.iter('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}p'):
        texts = [node.text for node in p.iter('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}t') if node.text]
        if texts:
            paragraphs.append(''.join(texts))
            
    full_text = '\n'.join(paragraphs)
    with open("extracted_doc.txt", "w", encoding="utf-8") as out:
        out.write(full_text)
    print(f"Written {len(paragraphs)} paragraphs to extracted_doc.txt")
