#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[3]:


customers = pd.read_csv(r"C:\Users\LENOVO\Documents\DA-Test\customers.csv")


# In[4]:


subscriptions = pd.read_csv(r"C:\Users\LENOVO\Documents\DA-Test\subscriptions.csv")


# In[5]:


events = pd.read_csv(r"C:\Users\LENOVO\Documents\DA-Test\events.csv")


# In[6]:


customers.head()


# In[7]:


subscriptions.head()


# In[8]:


events.head()


# In[9]:


customers.isna().sum()


# In[10]:


subscriptions.duplicated().sum()


# In[11]:


events.info()


# In[12]:


events['event_type'].value_counts()


# In[13]:


events['source'].value_counts()


# In[14]:


events.duplicated().sum()


# In[16]:


customers.duplicated().sum()


# In[ ]:




