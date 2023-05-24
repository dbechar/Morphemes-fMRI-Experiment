import os
import random
import pandas as pd

random.seed(1)

# NUMBER OF PARTICIPANTS
num_par = 20

# DEFINE LANGUAGE OF EXPERIMENT ("english" OR "french")
language = 'french'

# DEFINE BLOCK CONFIGURATION OPTIONS
block_config_options = [['pseudo', 'real', 'pseudo', 'real'],
                        ['real', 'pseudo', 'real', 'pseudo']]

output_dir = f'../triallists/{language}'
os.makedirs(output_dir, exist_ok=True)

for par in range(num_par):
    
    # READ IN CORRECT TRIALLISTS
    real_list = pd.read_csv(f'../triallists/temp_lists/{language}_real/{str(par)}.csv')
    pseudo_list = pd.read_csv(f'../triallists/temp_lists/{language}_pseudo/{str(par)}.csv')

    # RANDOMIZE BLOCK CONFIGURATION
    block_config = random.choice(block_config_options)

    # DIVIDE REAL AND PSEUOD TRIALS INTO TWO EQUAL PARTS
    real_list_part1 = real_list[:120]
    real_list_part2 = real_list[120:]
    pseudo_list_part1 = pseudo_list[:120]
    pseudo_list_part2 = pseudo_list[120:]

    df_final = pd.DataFrame()

    # MERGE TRIALS AND ADD BLOCK INFORMATION
    block_num = 1
    for block_type in block_config:
        if block_type == 'real':
            if block_num % 2 != 0:
                if not real_list_part1.empty:
                    df_final = pd.concat([df_final, real_list_part1.assign(block=f'block{block_num}')])
                    real_list_part1 = pd.DataFrame()
                else:
                    df_final = pd.concat([df_final, real_list_part2.assign(block=f'block{block_num}')])
                    real_list_part2 = pd.DataFrame()
            else:
                if not real_list_part2.empty:
                    df_final = pd.concat([df_final, real_list_part2.assign(block=f'block{block_num}')])
                    real_list_part2 = pd.DataFrame()
                else:
                    df_final = pd.concat([df_final, real_list_part1.assign(block=f'block{block_num}')])
                    real_list_part1 = pd.DataFrame()
        elif block_type == 'pseudo':
            if block_num % 2 != 0:
                if not pseudo_list_part1.empty:
                    df_final = pd.concat([df_final, pseudo_list_part1.assign(block=f'block{block_num}')])
                    pseudo_list_part1 = pd.DataFrame()
                else:
                    df_final = pd.concat([df_final, pseudo_list_part2.assign(block=f'block{block_num}')])
                    pseudo_list_part2 = pd.DataFrame()
            else:
                if not pseudo_list_part2.empty:
                    df_final = pd.concat([df_final, pseudo_list_part2.assign(block=f'block{block_num}')])
                    pseudo_list_part2 = pd.DataFrame()
                else:
                    df_final = pd.concat([df_final, pseudo_list_part1.assign(block=f'block{block_num}')])
                    pseudo_list_part1 = pd.DataFrame()
        block_num += 1

    # SAVE FINAL TRIALLIST
    df_final_path = f'{output_dir}/{str(par)}.csv'
    df_final.to_csv(df_final_path, index=False)
    print(f"Final list for participant {par} saved")
