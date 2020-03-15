import treetaggerwrapper as ttpw

en_tagger = ttpw.TreeTagger(TAGLANG='en', TAGOPT='-token -lemma -quiet')
fr_tagger = ttpw.TreeTagger(TAGLANG='fr', TAGOPT='-token -lemma -quiet')


def count_unk(tagged_text):
    n_unk = len([*filter(lambda t: t.lemma != '<unknown>', tagged_text)])
    return n_unk / len(tagged_text)


def tokens_to_sentence(tokens):
    return " ".join(t.word for t in tokens) + "\n"


def preprocess(tagger, inpath, outpath):
    with open(inpath) as f:
        corpus = f.readlines()

    tagged = (ttpw.make_tags(tagger.tag_text(txt.replace("’", "'")))
              for txt in corpus)

    filtered = filter(lambda doc: count_unk(doc) > .05, tagged)

    res = map(tokens_to_sentence, filtered)
    # print(res)
    with open(outpath, 'w') as f:
        f.writelines(res)


if __name__ == '__main__':
    # TODO: take paths as arguments
    print("#"*10, "Preprocessing English text", "#"*10)
    preprocess(en_tagger, '../data/corpora/anglais.txt',
               '../data/corpora/anglais_tok.txt')

    print("#"*10, "Preprocessing French text", "#"*10)
    preprocess(fr_tagger, '../data/corpora/francais.txt',
               '../data/corpora/francais_tok.txt')
