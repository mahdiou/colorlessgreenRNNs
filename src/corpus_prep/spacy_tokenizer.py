import spacy
from spacy.tokens import Doc


def get_num_unk_pos(doc):
    n_unk = sum((tok.pos_ == '' for tok in doc))
    return n_unk


def get_tok_doc(doc):
    res = (tok.text + (" " if tok.whitespace_ == '' else tok.whitespace_)
           for tok in doc)
    return res


def preprocess(nlp, inpath, outpath):
    with open(inpath) as f:
        corpus = f.readlines()

    with nlp.disable_pipes('ner'):
        tok = nlp.pipe(corpus)

    filtered = filter(lambda doc: doc._.n_unk_pos/len(doc) > .05, tok)

    res = map(lambda doc: doc._.tok_doc, filtered)
    with open(outpath, 'w') as f:
        f.writelines(res)


Doc.set_extension('n_unk_pos', getter=get_num_unk_pos)
Doc.set_extension('tok_doc', getter=get_tok_doc)

fr_nlp = spacy.load("fr_core_news_sm")
en_nlp = spacy.load("en_core_web_sm")


with open('francais.txt') as f:
    fr_text = f.read()

with open('anglais.txt') as f:
    en_text = f.read()

doc = fr_nlp.make_doc(fr_text)
res = (tok.text + (" " if tok.whitespace_ == '' else tok.whitespace_)
       for tok in doc)
with open('francais_tok.txt', 'w') as f:
    f.write("".join(res))

doc = en_nlp.make_doc(en_text)
res = (tok.text + (" " if tok.whitespace_ == '' else tok.whitespace_)
       for tok in doc)
with open('anglais_tok.txt', 'w') as f:
    f.write("".join(res))
