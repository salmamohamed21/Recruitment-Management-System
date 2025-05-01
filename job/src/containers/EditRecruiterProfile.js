import React, { useState, useEffect } from 'react';
import axios from 'axios';

const EditRecruiterProfile = () => {
  const [companyName, setCompanyName] = useState('');
  const [companyDescription, setCompanyDescription] = useState('');
  const [logoFile, setLogoFile] = useState(null);
  const [coverFile, setCoverFile] = useState(null);
  const [logoPreview, setLogoPreview] = useState('');
  const [coverPreview, setCoverPreview] = useState('');
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('/api/update_recruiter_profile/', {
          headers: { Authorization: `Token ${token}` },
        });
        const data = response.data;
        setCompanyName(data.name || '');
        setCompanyDescription(data.description || '');
        setLogoPreview(data.logo || '');
        setCoverPreview(data.cover || '');
      } catch (err) {
        setError('Failed to load profile data');
      } finally {
        setLoading(false);
      }
    };
    fetchProfile();
  }, []);

  const handleLogoChange = (e) => {
    const file = e.target.files[0];
    setLogoFile(file);
    setLogoPreview(URL.createObjectURL(file));
  };

  const handleCoverChange = (e) => {
    const file = e.target.files[0];
    setCoverFile(file);
    setCoverPreview(URL.createObjectURL(file));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMessage('');
    setError('');
    const formData = new FormData();
    formData.append('name', companyName);
    formData.append('description', companyDescription);
    if (logoFile) formData.append('logo', logoFile);
    if (coverFile) formData.append('cover', coverFile);

    try {
      const token = localStorage.getItem('token');
      await axios.put('/api/update_recruiter_profile/', formData, {
        headers: {
          Authorization: `Token ${token}`,
          'Content-Type': 'multipart/form-data',
        },
      });
      setMessage('Profile updated successfully');
    } catch (err) {
      setError('Failed to update profile');
    }
  };

  if (loading) return <div>Loading profile...</div>;

  return (
    <div>
      <h2>Edit Recruiter Profile</h2>
      {message && <p style={{ color: 'green' }}>{message}</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      <form onSubmit={handleSubmit}>
        <div>
          <label>Company Name:</label>
          <input
            type="text"
            value={companyName}
            onChange={(e) => setCompanyName(e.target.value)}
          />
        </div>
        <div>
          <label>Company Description:</label>
          <textarea
            value={companyDescription}
            onChange={(e) => setCompanyDescription(e.target.value)}
          />
        </div>
        <div>
          <label>Logo:</label>
          <input type="file" accept="image/*" onChange={handleLogoChange} />
          {logoPreview && (
            <div>
              <img src={logoPreview} alt="Logo Preview" style={{ width: '100px' }} />
            </div>
          )}
        </div>
        <div>
          <label>Cover:</label>
          <input type="file" accept="image/*" onChange={handleCoverChange} />
          {coverPreview && (
            <div>
              <img src={coverPreview} alt="Cover Preview" style={{ width: '200px' }} />
            </div>
          )}
        </div>
        <button type="submit">Save Profile</button>
      </form>
    </div>
  );
};

export default EditRecruiterProfile;
