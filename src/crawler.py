import requests
from bs4 import BeautifulSoup

class Crawler:
    def __init__(self, results):
        self.links = [item['link'] for item in results]

    def crawl(self):
        crawled_data = []
        for link in self.links:
            #print(f"Fetching {link}")
            try:
                response = requests.get(link)
                if response.status_code == 200:
                    soup = BeautifulSoup(response.text, 'html.parser')
                    paragraphs = ' '.join([p.get_text() for p in soup.find_all('p')])
                    code_blocks = ' '.join([code.get_text() for code in soup.find_all('code')])
                    # Extraer texto de las etiquetas <span> dentro de <code>
                    for code in soup.find_all('code'):
                        code_blocks += ' ' + ' '.join([span.get_text() for span in code.find_all('span')])
                    content = paragraphs + "\n" + code_blocks

                    crawled_data.append({
                        'url': link,
                        'content': content
                    })
            except Exception as e:
                print(f"Error fetching {link}: {e}")
        return crawled_data