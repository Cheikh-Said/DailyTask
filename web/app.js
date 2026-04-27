const API_BASE = 'http://localhost:8080'; 

// DOM Elements (Check if they exist before using)
const btnRecommend = document.getElementById('btn-recommend');
const btnRank = document.getElementById('btn-rank');
const recUserId = document.getElementById('rec-user-id');
const resultsContainer = document.getElementById('recommendations-results');

const formAddPaper = document.getElementById('form-add-paper');
const formAddUser = document.getElementById('form-add-user');
const formAddFeedback = document.getElementById('form-add-feedback');
const toastContainer = document.getElementById('toast-container');

// Event Listeners
if (btnRecommend) {
    btnRecommend.addEventListener('click', () => fetchRecommendations(false));
}
if (btnRank) {
    btnRank.addEventListener('click', () => fetchRecommendations(true));
}

if (formAddPaper) {
    formAddPaper.addEventListener('submit', async (e) => {
        e.preventDefault();
        const id = document.getElementById('paper-id').value.trim();
        const title = document.getElementById('paper-title').value.trim();
        const keywords = document.getElementById('paper-keywords').value.trim();
        const year = document.getElementById('paper-year').value.trim();
        const authors = document.getElementById('paper-authors').value.trim();
        
        await makeApiCall('/add_paper', { id, title, keywords, year, authors });
        showToast(`Paper ${id} added successfully!`);
        formAddPaper.reset();
    });
}

if (formAddUser) {
    formAddUser.addEventListener('submit', async (e) => {
        e.preventDefault();
        const id = document.getElementById('user-id').value.trim();
        const interests = document.getElementById('user-interests').value.trim();
        const authors = document.getElementById('user-authors').value.trim();
        const excluded = document.getElementById('user-excluded').value.trim();
        
        await makeApiCall('/add_user', { id, interests, authors, excluded });
        showToast(`User ${id} added successfully!`);
        formAddUser.reset();
    });
}

if (formAddFeedback) {
    formAddFeedback.addEventListener('submit', async (e) => {
        e.preventDefault();
        const user = document.getElementById('feedback-user').value.trim();
        const paper = document.getElementById('feedback-paper').value.trim();
        
        await makeApiCall('/add_feedback', { user, paper });
        showToast(`Feedback recorded for ${user} on paper ${paper}!`);
        formAddFeedback.reset();
    });
}

// Helper Functions
async function fetchRecommendations(isRanked = false) {
    const userId = recUserId.value.trim();
    if (!userId) {
        showToast('Please enter a User ID', 'error');
        return;
    }
    
    resultsContainer.innerHTML = '<p>Loading...</p>';
    
    try {
        const endpoint = isRanked ? `/rank?user=${userId}&n=5` : `/recommend?user=${userId}`;
        const response = await fetch(API_BASE + endpoint);
        const data = await response.json();
        
        renderResults(data.results || data.recommendations);
    } catch (error) {
        resultsContainer.innerHTML = '<p>Error fetching recommendations.</p>';
        console.error('Error:', error);
    }
}

async function makeApiCall(endpoint, params) {
    const queryStr = new URLSearchParams(params).toString();
    const url = `${API_BASE}${endpoint}?${queryStr}`;
    
    try {
        const response = await fetch(url);
        return await response.json();
    } catch (error) {
        console.error('API Error:', error);
        throw error;
    }
}

function renderResults(papers) {
    if (!papers || papers.length === 0) {
        resultsContainer.innerHTML = '<p>No recommendations found for this user.</p>';
        return;
    }
    
    resultsContainer.innerHTML = '';
    
    papers.forEach(p => {
        const authorsStr = Array.isArray(p.authors) ? p.authors.join(', ') : p.authors;
        const score = p.score ? parseFloat(p.score).toFixed(1) : '?';
        
        const el = document.createElement('div');
        el.className = 'paper-item';
        el.innerHTML = `
            <strong>${p.title} (${p.paper_id})</strong> - Score: ${score}<br>
            <small>Year: ${p.year} | Authors: ${authorsStr}</small><br>
            <small>Keywords: ${p.keywords.join(', ')}</small>
        `;
        resultsContainer.appendChild(el);
    });
}

function showToast(message, type = 'success') {
    if (!toastContainer) return;
    const toast = document.createElement('div');
    toast.className = 'toast';
    if (type === 'error') {
        toast.style.borderColor = '#ebccd1';
        toast.style.color = '#a94442';
        toast.style.backgroundColor = '#f2dede';
    }
    toast.textContent = message;
    
    toastContainer.appendChild(toast);
    
    setTimeout(() => {
        toast.remove();
    }, 3000);
}
