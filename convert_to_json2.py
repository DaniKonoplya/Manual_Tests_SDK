import re
from pprint import pprint
import pathlib
import json

all_projects = dict()
current_file_location = str(pathlib.Path(__file__).parent.absolute()) + '\\'


def appender(f, project):
    chip_step = re.sub(r'.*:', '', next(f).strip())
    if all_projects['Project'][project]:
        all_projects['Project'][project]['Chip_step'][chip_step] = {}
    else:
        all_projects['Project'][project] = {'Chip_step': {chip_step: {}}}

    columns = next(f).split(',')
    data = next(f).strip().split(',')

    def rec_appender(data=data, base=all_projects['Project'][project]['Chip_step'][chip_step]):
        def rec_int_appender(el, ind, base):
            if base.keys():
                if not data[ind].strip() in base[list(base.keys())[0]]:
                    base[el.strip()][data[ind].strip()] = {}
            else:
                if ind < len(data) - 1:
                    base[el.strip()] = {data[ind]: {}}
                else:
                    base[el.strip()] = data[ind]
                    return
            base = base[el.strip()][data[ind]]
            rec_int_appender(columns[ind + 1], ind + 1, base)

        rec_int_appender(columns[0], 0, base)
        try:
            rec_appender(data=next(f).strip().split(','))
        except StopIteration:
            return

    rec_appender()


all_projects['Project'] = {}

for path in [current_file_location + 'one.csv', current_file_location + 'two.csv']:
    with open(path) as f:
        project = re.sub(r'.*:', '', next(f).strip())
        if project not in all_projects['Project']:
            all_projects['Project'][project] = {}
        appender(f, project)

pprint(all_projects)
json_data = json.dumps(all_projects)

with open(current_file_location + 'js_result.json', 'w') as f:
    f.write(json_data)
