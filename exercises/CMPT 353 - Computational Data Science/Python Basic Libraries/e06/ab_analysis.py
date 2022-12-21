import sys
import numpy as np
import pandas as pd
from scipy import stats

OUTPUT_TEMPLATE = (
    '"Did more/less users use the search feature?" p-value:  {more_users_p:.3g}\n'
    '"Did users search more/less?" p-value:  {more_searches_p:.3g} \n'
    '"Did more/less instructors use the search feature?" p-value:  {more_instr_p:.3g}\n'
    '"Did instructors search more/less?" p-value:  {more_instr_searches_p:.3g}'
)


def main():
    searchdata_file = sys.argv[1]

    # read json file
    data = pd.read_json(searchdata_file, orient='records', lines=True)
    
    # seperate two search features
    old_search = data[data['uid'] % 2 == 0]
    new_search = data[data['uid'] % 2 == 1]

    # do a non-paramatic test: to check if more people search with the new design
    more_users = stats.mannwhitneyu(new_search['login_count'], old_search['login_count'])

    # seperate zero and non-zero search counts from two search (old and new) features
    old_zeros = old_search[old_search['search_count'] == 0]['uid'].count()
    old_nonzs = old_search[old_search['search_count'] > 0]['uid'].count()
    new_zeros = new_search[new_search['search_count'] == 0]['uid'].count()
    new_nonzs = new_search[new_search['search_count'] > 0]['uid'].count()
    # create contingency table 
    contingency = [[old_zeros, old_nonzs],
                   [new_zeros, new_nonzs]]

    # do a test (categorical): to check if people more search with the new design
    chi2, searches_p, dof, expected = stats.chi2_contingency(contingency)

    # seperate instructors 
    old_inst = old_search[old_search['is_instructor'] == True]
    new_inst = new_search[new_search['is_instructor'] == True]

    # do a non-paramatic test: to check if more instructors search with the new design
    more_instr = stats.mannwhitneyu(new_inst['login_count'], old_inst['login_count'])

    # seperate zero and non-zero instructors search
    old_inst_zeros = old_inst[old_inst['search_count'] == 0]['uid'].count()
    old_inst_nonzs = old_inst[old_inst['search_count'] > 0]['uid'].count()
    new_inst_zeros = new_inst[new_inst['search_count'] == 0]['uid'].count()
    new_inst_nonzs = new_inst[new_inst['search_count'] > 0]['uid'].count()
    # create contingency table for instructors
    contingency_inst = [[old_inst_zeros, old_inst_nonzs],
                   [new_inst_zeros, new_inst_nonzs]]

    # do a test (categorical): to check if instructors made more search with the new design
    chi2_inst, instr_searches_p, dof_inst, expected_inst = stats.chi2_contingency(contingency_inst)
    

    # Output
    print(OUTPUT_TEMPLATE.format(
        more_users_p = more_users.pvalue,
        # p-value: 0.215 > 0.05, we can conclude that user logins with the new search feature are almost as frequest as with the old search feature
        more_searches_p = searches_p,
        # p-value: 0.168 > 0.05, we can conclude that users do not search more with the new feature
        more_instr_p = more_instr.pvalue,
        # p-value: 0.898 > 0.05, we can conclude that instructor logins with the new search feature are almost as frequest as with the old search feature
        more_instr_searches_p = instr_searches_p,
        # p-value: 0.052 >= 0.05, we can conclude that instructors do not search more with the new feature
    ))


if __name__ == '__main__':
    main()
