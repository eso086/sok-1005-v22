{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "10fafc86-b3a1-46d2-a09e-432d730dc6b8",
   "metadata": {},
   "outputs": [
    {
     "ename": "ModuleNotFoundError",
     "evalue": "No module named 'blotto'",
     "output_type": "error",
     "traceback": [
      "\u001b[0;31m---------------------------------------------------------------------------\u001b[0m",
      "\u001b[0;31mModuleNotFoundError\u001b[0m                       Traceback (most recent call last)",
      "Input \u001b[0;32mIn [1]\u001b[0m, in \u001b[0;36m<module>\u001b[0;34m\u001b[0m\n\u001b[0;32m----> 1\u001b[0m \u001b[38;5;28;01mimport\u001b[39;00m \u001b[38;5;21;01mblotto\u001b[39;00m\n\u001b[1;32m      4\u001b[0m \u001b[38;5;28;01mimport\u001b[39;00m \u001b[38;5;21;01mnumpy\u001b[39;00m \u001b[38;5;28;01mas\u001b[39;00m \u001b[38;5;21;01mnp\u001b[39;00m\n\u001b[1;32m      6\u001b[0m \u001b[38;5;28;01mdef\u001b[39;00m \u001b[38;5;21mplayer_strategy\u001b[39m(n_battalions,n_fields):\n\u001b[1;32m      7\u001b[0m     \u001b[38;5;66;03m#defining the array:\u001b[39;00m\n",
      "\u001b[0;31mModuleNotFoundError\u001b[0m: No module named 'blotto'"
     ]
    }
   ],
   "source": [
    "import blotto\n",
    "\n",
    "\n",
    "import numpy as np\n",
    "\n",
    "def player_strategy(n_battalions,n_fields):\n",
    "    #defining the array:\n",
    "    battalions=np.zeros(n_fields,dtype=int)\n",
    "    \n",
    "    #assigning 25 battalions to the first four battle fields:\n",
    "    battalions[0]=2\n",
    "    battalions[1]=31\n",
    "    battalions[2]=31\n",
    "    battalions[3]=31\n",
    "    battalions[4]=23\n",
    "    battalions[5]=2\n",
    "    \n",
    "    \n",
    "    \n",
    "    #asserting that all and no more than all battalions are used:\n",
    "    battalions=battalions[np.random.rand(n_fields).argsort()]\n",
    "    assert sum(battalions)==n_battalions\n",
    "    \n",
    "    return battalions\n",
    "\n",
    "\n",
    "def computer_strategy(n_battalions,n_fields):\n",
    "    battalions=np.zeros(n_fields,dtype=int)\n",
    "    battalions[0:1]=8\n",
    "    battalions[1:4]=30\n",
    "    battalions[4]=22\n",
    "    battalions[5]=0\n",
    "\n",
    "    \n",
    "    assert sum(battalions)==n_battalions\n",
    "    return battalions\n",
    "\n",
    "#blotto.run(6,120,player_strategy, computer_strategy)\n",
    "\n",
    "\n",
    "def call_battle(n_battalions,n_fields, player_strategy, computer_strategy):\n",
    "    c_battlions=computer_strategy(n_battalions,n_fields)\n",
    "    p_battlions=player_strategy(n_battalions,n_fields)\n",
    "\n",
    "    diff=p_battlions-c_battlions\n",
    "    points=sum(diff>0)-sum(diff<0)\n",
    " \n",
    "    return int(points>0)-int(points<0)\n",
    "\n",
    "def test_strategies(n_fields,n_battalions,player_strategy, computer_strategy):\n",
    "    n_tests=100000\n",
    "    r=0\n",
    "    record=[]\n",
    "    for i in range(n_tests):\n",
    "        p=call_battle(n_battalions,n_fields,\n",
    "            player_strategy, computer_strategy)\n",
    "        record.append(p)\n",
    "        r+=p\n",
    "    return r/n_tests\n",
    "\n",
    "score=test_strategies(6,120,player_strategy, computer_strategy)\n",
    "print(score)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "f3dea9f5-0bb1-477d-8ac9-465fa0a9676f",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.9.9"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
